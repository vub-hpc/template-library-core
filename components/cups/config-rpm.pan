# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Michel Jouvin <jouvin@lal.in2p3.fr>
#

# 
# #
# cups, 17.3.0, 1, Thu Jun 15 2017
#

unique template components/cups/config-rpm;

include 'components/cups/config-common';

# Set prefix to root of component configuration.
prefix '/software/components/cups';

# Install Quattor configuration module via RPM package.
'/software/packages' = pkg_repl('ncm-cups','17.3.0-1','noarch');
'dependencies/pre' ?= list('spma');

