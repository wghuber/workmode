#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:xenial

# Create environment for user
ENV USER office
RUN useradd -ms /bin/zsh $USER && \
    usermod -aG sudo $USER && \
    passwd -de $USER

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
                  tmux byobu emacs curl git htop man tar unzip vim wget zsh fontconfig \
                  python2.7 python-pip python3 python3-pip graphviz ispell dbus-x11 mesa-utils \
                  cmake clang clang-format clang-tidy g++ ninja-build sudo \
                  ros-kinetic-desktop-full python-rosinstall python-rosinstall-generator \
                  python-wstool build-essential python-catkin-tools python-rosdep && \
  eatmydata pip install --upgrade pip && \
  eatmydata pip install jupyter numpy scipy matplotlib pandas tensorflow tensorboard vispy pytest \
              scikit-learn pytest-cov pylint && \
  eatmydata pip3 install --upgrade pip && \
  eatmydata pip3 install jupyter numpy scipy matplotlib pandas tensorflow tensorboard vispy pytest \
              scikit-learn pytest-cov pylint

# Update fonts
ADD assets/SourceCodePro-Medium.ttf /usr/local/share/fonts/SourceCodePro-Medium.ttf
RUN fc-cache -fv

# Define user
USER office

# Set environment variables.
ENV HOME /home/$USER
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install zsh and spacemacs
RUN \
  eatmydata git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh && \
  eatmydata git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

# Add files.
ADD home/.zshrc $HOME/.zshrc
ADD home/.gitconfig $HOME/.gitconfig
ADD home/.spacemacs $HOME/.spacemacs

# Define working directory.
WORKDIR $HOME

# Define default command.
ENTRYPOINT ["zsh"]
