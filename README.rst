========
jetbrains rider
========

Formula for latest Rider IDE from Jetbrains. 

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    Refer to pillar.example and defaults.yaml for configurable values. Tested on Linux (Ubuntu, Fedora, Arch, and Suse), MacOS. Not verified on Windows OS.
    
Available states
================

.. contents::
    :local:

``rider``
------------

Downloads the archive from Jetbrains website, unpacks locally and installs to the Operating System.

.. note::

This formula automatically installs latest Jetbrains release. This behaviour may be overridden in pillars.


``rider.developer``
------------
Create Desktop shortcuts. Optionally retrieve settings file from url/share and save to 'user' (pillar) home directory.


``rider.linuxenv``
------------
On Linux, the PATH is set for all system users by adding software profile to /etc/profile.d/ directory. Full support for debian linuxenv in supported Linux distributions (i.e. not Archlinux).

.. note::

Enable Debian alternatives by setting nonzero 'altpriority' pillar value; otherwise feature is disabled.

