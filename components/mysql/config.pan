# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Michel Jouvin <jouvin@lal.in2p3.fr>
#

# #
# Author(s): Jane SMITH, Joe DOE
#

# #
      # mysql, 14.8.0-rc5, rc5_1, 20140905-1421
      #

unique template components/mysql/config;

include { 'components/mysql/config-common' };
include { 'components/mysql/config-rpm' };
