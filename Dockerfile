FROM archlinux:latest

#install xcowsay-deps
#    depends=('dbus' 'dbus-glib' 'cairo' 'gtk2')
ENV XCOWSAY_DEPS="dbus dbus-glib cairo gtk2"
RUN yes "y" | pacman -Syy
RUN sleep 30m


#install yarout deps
# deps:
#    yaourt=(diffutils  pacman>=5.0  package-query>=1.8  gettext)



ENV YAOURT_HIDDEN_DEPS "yajl diffutils gettext"
# package-query dependencies
ENV YAOURT_USER "yaourt"


RUN yes "y" | pacman -S $YAOURT_HIDDEN_DEPS

RUN useradd --no-create-home --shell=/bin/false $YAOURT_USER && usermod -L $YAOURT_USER

RUN mkdir -p /tmp/Package/ && chown $YAOURT_USER /tmp/Package
USER $YAOURT_USER
RUN cd /tmp/Package && pwd && ls -al && $YAOURT_USER --getpkgbuild aur/taskd && cd taskd && makepkg --pkg taskd 
USER root
RUN pacman -U --noconfirm /tmp/Package/taskd/taskd-1.1.0-1-x86_64.pkg.tar.xz

# ENV NOBODY_BUILD_DIR /home/build
# RUN mkdir $NOBODY_BUILD_DIR
# RUN chgrp nobody $NOBODY_BUILD_DIR
# RUN chmod g+ws $NOBODY_BUILD_DIR
# RUN setfacl -m u::rwx,g::rwx $NOBODY_BUILD_DIR
# RUN setfacl -d --set u::rwx,g::rwx,o::- $NOBODY_BUILD_DIR
# RUN sleep 20m
# RUN su -u nobody makepkg

# #install required packages
# # deps:
# #     xcowsay=('dbus' 'dbus-glib' 'cairo' 'gtk2')



# # Replace 1000 with your user / group id
# RUN export uid=1000 gid=1000 && \
#     mkdir -p /home/developer && \
#     echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
#     echo "developer:x:${uid}:" >> /etc/group && \
#     echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
#     chmod 0440 /etc/sudoers.d/developer && \
#     chown ${uid}:${gid} -R /home/developer

# USER developer
# ENV HOME /home/developer
# CMD /usr/bin/firefox
