# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   David Groep <davidg@nikhef.nl>
#

# #
# Author(s): Jane SMITH, Joe DOE
#

# #
# pbsclient, 15.2.0-rc5, rc5_1, 20150319-1200
#

unique template components/pbsclient/config-common;

include { 'components/pbsclient/schema' };

# Set prefix to root of component configuration.
prefix '/software/components/pbsclient';

'version' = '15.2.0';
#'package' = 'NCM::Component';

'active' ?= true;
'dispatch' ?= true;
