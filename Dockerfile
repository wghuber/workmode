#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:xenial

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list && \
  apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
  apt-get update && \
  apt-get install -y eatmydata && \
  eatmydata apt-get -y upgrade && \
  eatmydata apt-get install -y build-essential locales locales-all && \
  eatmydata apt-get install -y software-properties-common && \
  eatmydata apt-get install -y \
                  tmux byobu emacs curl htop man tar unzip vim wget zsh fontconfig ispell dbus-x11 mesa-utils \
                  hg git python2.7 python-pip python3 python3-pip graphviz cmake clang clang-format clang-tidy g++ ninja-build \
                  ros-kinetic-desktop-full python-rosinstall python-rosinstall-generator python-wstool python-catkin-tools python-rosdep gazebo7 \
                  krb5-user sssd-tools sssd-krb5 sssd-ldap sssd-dbus sssd-ad sssd && \
  eatmydata pip install --upgrade pip && \
  eatmydata pip install jupyter numpy scipy matplotlib pandas tensorflow tensorboard vispy pytest \
              scikit-learn pytest-cov pylint && \
  eatmydata pip3 install --upgrade pip && \
  eatmydata pip3 install jupyter numpy scipy matplotlib pandas tensorflow tensorboard vispy pytest \
              scikit-learn pytest-cov pylint

# Update fonts
ADD assets/SourceCodePro-Medium.ttf /usr/local/share/fonts/SourceCodePro-Medium.ttf
RUN fc-cache -fv

# Set environment variables.
ENV HOME /root/$USER
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install zsh and spacemacs
RUN \
  eatmydata git clone git://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh && \
  eatmydata git clone https://github.com/syl20bnr/spacemacs /root/.emacs.d

# RUN eatmydata git clone https://github.com/syl20bnr/spacemacs-elpa-mirror.git /root/elpamirror

# Add files.
ADD home/.zshrc /root/.zshrc
ADD home/.gitconfig /root/.gitconfig
ADD home/.spacemacs /root/.spacemacs

# Define working directory.
WORKDIR /root

# Define default command.
ENTRYPOINT ["zsh"]
