# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Luis Fernando Muñoz Mejías <Luis.Munoz@UGent.be>
#

# 
# #
# ccm, 15.4.0-rc12, rc12_1, 2015-06-03T08:50:01Z
#

unique template components/ccm/config;
include 'components/ccm/schema';

'/software/packages' = pkg_repl('ncm-ccm','15.4.0-rc12_1','noarch');

prefix '/software/components/ccm';
'dependencies/pre' ?= list ('spma');
'active' ?= true;
'dispatch' ?= true;
'version' ?= '15.4.0';
