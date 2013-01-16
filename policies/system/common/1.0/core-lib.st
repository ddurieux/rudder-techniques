#####################################################################################
# Copyright 2011 Normation SAS
#####################################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, Version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#####################################################################################

# This our core-library of common 
# function. That's our knowledge !
#
# Just bodies and editbundles here
#
############################################



body depth_search recurse_visible(d) {
    depth        => "$(d)";
    exclude_dirs => { "\..*" };
}

#perms validation
body perms u_p(p) {
  mode  => "$(p)";
}

#########################################################
#server may be a list
body copy_from cp(from,server) {
  servers     => { "${server}" };
  source      => "$(from)";
  compare     => "digest";
community_edition::
 	portnumber => "&COMMUNITYPORT&";
  
}

body copy_from scp(from, server,compare,trustkey,preserve,purge) {
  servers  => { "${server}" };
  source   => "$(from)";
  compare  => "$(compare)";
  encrypt  => "true";
  verify   => "true";
  trustkey => "${trustkey}";
  preserve => "${preserve}"; #preserver permissions
  purge    => "${purge}";
community_edition::
 	portnumber => "&COMMUNITYPORT&";
}


body copy_from copy(from) {
	source => "$(from)";
	copy_backup => "false";
	preserve => "true";
}

body copy_from copy_digest(from) {
        source => "$(from)";
        copy_backup => "false";
        preserve => "true";
	compare => "digest";
}

#########################################################
body classes class_trigger(if,else,kept)
{
promise_kept => { "$(kept)" };
promise_repaired => { "$(if)" };
repair_failed => { "$(else)" };
repair_denied    => { "$(else)" };
repair_timeout   => { "$(else)" };
}

#########################################################
body location append
{
before_after => "after";
}

#########################################################
body package_method yum_remi
{
 package_changes => "bulk";
 package_list_command => "/usr/bin/yum list installed";
 package_list_name_regex    => "([^.]+).*";
 package_list_version_regex => "[^\s]\s+([^\s]+).*";
 package_list_arch_regex    => "[^.]+\.([^\s]+).*";
 package_installed_regex => ".*installed.*";
 package_name_convention => "$(name).$(arch)";
 package_add_command => "/usr/bin/yum --enablerepo=remi -y install";
 package_delete_command => "/bin/rpm -e";
 package_verify_command => "/bin/rpm -V";
}