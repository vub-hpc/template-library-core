# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Alvaro Simon Garcia <Alvaro.SimonGarcia@UGent.be>
#

# 
# #
# opennebula, 16.6.0-rc4, rc4_1, Fri Jul 15 2016
#

unique template components/opennebula/config-common;

include { 'components/opennebula/schema' };

bind '/software/components/opennebula' = component_opennebula;


# Set prefix to root of component configuration.
prefix '/software/components/opennebula';

#'version' = '16.6.0-rc4';
#'package' = 'NCM::Component';

'active' ?= true;
'dispatch' ?= true;
