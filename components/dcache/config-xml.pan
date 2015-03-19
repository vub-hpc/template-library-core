# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Stijn.De.Weirdt@cern.ch <Stijn.De.Weirdt@cern.ch>
#

# #
# Author(s): Jane SMITH, Joe DOE
#

# #
# dcache, 15.2.0-rc5, rc5_1, 20150319-1200
#

unique template components/dcache/config-xml;

include { 'components/dcache/config-common' };

# Set prefix to root of component configuration.
prefix '/software/components/dcache';

# Embed the Quattor configuration module into XML profile.
'code' = file_contents('components/dcache/dcache.pm'); 
