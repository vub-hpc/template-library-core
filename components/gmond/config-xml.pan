# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Ronald Starink <ronalds@nikhef.nl>
#

# 
# #
# gmond, 15.4.0-rc12, rc12_1, 2015-06-03T08:50:01Z
#

unique template components/gmond/config-xml;

include { 'components/gmond/config-common' };

# Set prefix to root of component configuration.
prefix '/software/components/gmond';

# Embed the Quattor configuration module into XML profile.
'code' = file_contents('components/gmond/gmond.pm'); 
