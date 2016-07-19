=========
aptmirror
=========

.. note::

    See the full `Salt Formulas installation and usage instructions <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``aptmirror``
----------

Mirrors apt repositories

Testing
=======

Testing is done with kitchen-salt

``kitchen converge``
--------------------

Runs the formula

``kitchen verify``
------------------

Runs serverspec tests on the actual instance

``kitchen test``
----------------

Builds and runs test from scratch

``kitchen login``
-----------------

Gives you ssh to the vagrant machine for manual testing
