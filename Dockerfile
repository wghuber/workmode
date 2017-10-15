#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:zesty

ENV DEBIAN_FRONTEND noninteractive

# Install.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y eatmydata lsb-release dirmngr
RUN eatmydata apt-get -y upgrade
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update
RUN eatmydata apt-get install -y build-essential locales locales-all software-properties-common
RUN eatmydata apt-get install -y \
                  tmux byobu emacs curl htop man tar unzip vim wget zsh fontconfig ispell dbus-x11 mesa-utils sudo \
                  git mercurial mercurial-git python2.7 python-pip python3 python3-pip graphviz cmake clang clang-format clang-tidy g++ ninja-build \
                  krb5-user sssd-tools sssd-krb5 sssd-ldap sssd-dbus sssd-ad sssd \
                  ros-lunar-desktop-full gazebo7 \
                  docker docker.io docker-compose
RUN eatmydata pip install --upgrade pip
RUN eatmydata pip install jupyter numpy scipy matplotlib pandas tensorflow tensorboard vispy pytest \
              scikit-learn pytest-cov pylint ansible docker-py scrapy requests Pillow werkzeug PyYAML \
              Sphinx seaborn bokeh plotly theano keras networkx pybrain sympy \
              jupyter-git jupyter-tensorboard jupyter-sphinx-theme jupyter_sphinx jupyter_contrib_nbextensions jupyter-alabaster-theme \
              jupyter_nbextensions_configurator jupyter-beautifier jupyter_dashboards jupyter-tree-filter jupyter-tools
RUN eatmydata pip3 install --upgrade pip
RUN eatmydata pip3 install jupyter numpy scipy matplotlib pandas tensorflow tensorboard vispy pytest \
              scikit-learn pytest-cov pylint ansible docker-py scrapy requests PyQt5 Pillow werkzeug \
              PyYAML Sphinx seaborn bokeh plotly theano keras networkx pybrain sympy \
              jupyter-git jupyter-tensorboard jupyter-sphinx-theme jupyter_sphinx jupyter_contrib_nbextensions jupyter-alabaster-theme \
              jupyter_nbextensions_configurator jupyter-beautifier jupyter_dashboards jupyter-tree-filter jupyter-tools

# Update fonts
ADD assets/SourceCodePro-Medium.ttf /usr/local/share/fonts/SourceCodePro-Medium.ttf
RUN fc-cache -fv

# Install PyCharm and CLion
RUN eatmydata wget https://download.jetbrains.com/python/pycharm-professional-2017.2.3.tar.gz
RUN eatmydata wget https://download.jetbrains.com/cpp/CLion-2017.2.3.tar.gz
RUN tar -xzf pycharm-professional-2017.2.3.tar.gz -C /opt/
RUN tar -xzf CLion-2017.2.3.tar.gz -C /opt/
RUN ln -s /opt/clion-2017.2.3/bin/clion.sh /usr/bin/clion
RUN ln -s /opt/pycharm-2017.2.3/bin/pycharm.sh /usr/bin/pycharm

# Set environment variables.
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create user.
ARG USER
ARG PASS
ARG UID
RUN useradd -s /bin/zsh -m -u $UID -G sudo,docker $USER
RUN echo "$USER:$PASS" | chpasswd

# Define working directory add files and set default shell.
ENV HOME /home/$USER/
ENTRYPOINT ["/bin/zsh"]
WORKDIR $HOME
ADD home/* $HOME

# Install oh-my-zsh and spacemacs.
RUN eatmydata git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
RUN eatmydata git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
#RUN eatmydata git clone https://github.com/syl20bnr/spacemacs-elpa-mirror.git $HOME/elpamirror

RUN chown -R $USER:$USER $HOME

USER $USER:$USER
