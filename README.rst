========
rider
========

Formula for latest Rider IDE from Jetbrains. 

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    
Available states
================

.. contents::
    :local:

``rider``
------------

Downloads the archive from Jetbrains website, unpacks locally and installs the IDE on the Operating System. On Linux, the PATH is set for all system users by adding software profile to /etc/profile.d/ directory.

.. note::

This formula automatically installs latest Jetbrains release. This behaviour may be overridden in pillars.

``rider.alternatives``
------------
Full support for debian alternatives in supported Linux distributions (i.e. not Archlinux, Windows, MacOS).

.. note::

The linux-alternatives 'priority' pillar value must be updated for each newly installed release/editions.

``rider.developer``
------------
Create Desktop shortcuts. Optionally get preferences file from url/share and save into 'user' (pillar) home directory.


Please see the pillar.example for configuration.

Tested on Linux (Ubuntu, Fedora, Arch, and Suse), MacOS. Not verified on Windows OS.
