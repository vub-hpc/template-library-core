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
# pbsknownhosts, 20.12.0, 1, Wed Jan 20 2021
#

unique template components/pbsknownhosts/config-common;

include 'components/pbsknownhosts/schema';

# Set prefix to root of component configuration.
prefix '/software/components/pbsknownhosts';

'version' = '20.12.0';
#'package' = 'NCM::Component';

'active' ?= true;
'dispatch' ?= true;
