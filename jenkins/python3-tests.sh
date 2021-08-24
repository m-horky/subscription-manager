# needs python-nose installed
# needs an xserver or vncserver running
# see http://www.oracle-base.com/articles/linux/configuring-vnc-server-on-linux.php for an example for f16
# needs polib installed, http://pypi.python.org/pypi/polib
# probably will need coverage tools installed
# systemctl start vncserver@:3.service
# systemctl stop vncserver@:3.service
# needs python-rhsm
# needs mock  (easy_install mock)
# needs pyflakes insalled
# if we haven't installed/ran subsctiption-manager (or installed it)
#   we need to make /etc/pki/product and /etc/pki/entitlement

#env

echo "GIT_COMMIT:" "${GIT_COMMIT}"

sudo yum clean expire-cache
sudo yum-builddep -y subscription-manager.spec || true # ensure we install any missing rpm deps
virtualenv env-tests -p python3 --system-site-packages || virtualenv env-tests --system-site-packages || true
source env-tests/bin/activate
pip install -I -r test-requirements.txt

# so we can run these all everytime, we don't actually fail on each step, so checkout for output
#TMPFILE=`mktemp`|| exit 1; $(make stylish | tee $TMPFILE); if [ -s $TMPFILE ] ; then echo "FAILED"; cat $TMPFILE; exit 1; fi

# build the c modules
python3 setup.py build
python3 setup.py build_ext --inplace

# make sure we have a dbus session for the dbus tests
dbus-run-session coverage run

coverage report
coverage xml
