# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Charles Loomis <charles.loomis@cern.ch>
#

# #
# Author(s): Jane SMITH, Joe DOE
#

# #
# gridmapdir, 18.3.0-rc4, rc4_1, Wed May 16 2018
#

unique template components/gridmapdir/config-rpm;

include 'components/gridmapdir/config-common';

# Set prefix to root of component configuration.
prefix '/software/components/gridmapdir';

# Install Quattor configuration module via RPM package.
'/software/packages' = pkg_repl('ncm-gridmapdir', '18.3.0-rc4_1', 'noarch');
'dependencies/pre' ?= list('spma');

