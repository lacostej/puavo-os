var child_process = require('child_process');
var fs = require('fs');

var config_json_path = '/state/etc/puavo/local.json';

function assemble_config_and_exit(old_config) {
  var response = document.forms[0].elements;
  var new_config = {};

  new_config.allow_login = response.allow_login.value;

  new_config.licenses = {};
  var license_checkboxes
    = document.querySelectorAll('input[class=license_acceptance_checkbox]');
  [].forEach.call(license_checkboxes,
                  function(lc) {
                    var name = lc.getAttribute('name');
                    new_config.licenses[name] = response[name].checked; });

  new_config.admins
    = response['localuser_0_admin_rights'].checked
        ? [ response['localuser_0_login'].value ]
        : [];

  var local_user_errors = document.querySelector('div[id=localuser_0_errors]');
  local_user_errors.innerHTML = '';
  if (response.localuser_0_password.value
        !== response.localuser_0_password_again.value) {
    local_user_errors.innerHTML = 'Passwords do not match.';
    return;
  }

  new_config.local_users = [
    {
      login: response['localuser_0_login'].value,
      name:  response['localuser_0_name' ].value,
    }
  ];

  // XXX should validate more properly
  if (new_config.local_users[0].login === '') {
    alert('Login is missing');
    return;
  }

  // XXX should validate more properly
  if (new_config.local_users[0].name === '') {
    alert('Name is missing');
    return;
  }

  hash_password(response['localuser_0_password'].value,
                old_config.local_users[0].hashed_password,
                function(hp) {
                  new_config.local_users[0].hashed_password = hp;
                  write_config_json_and_exit(new_config); });
}

function add_one_license(parentNode, license_info) {
  var tr = document.createElement('tr');

  // create checkbox element
  var td = document.createElement('td');
  var input = document.createElement('input');
  input.setAttribute('class', 'license_acceptance_checkbox');
  input.setAttribute('name', license_info.key);
  input.setAttribute('type', 'checkbox');
  tr.appendChild( td.appendChild(input) );

  // create license name element
  var td = document.createElement('td');
  td.textContent = license_info.name;
  tr.appendChild(td);

  // create license url link
  var td = document.createElement('td');
  var a = document.createElement('a');
  a.setAttribute('href', license_info.url);
  a.addEventListener('click',
                     function(e) { e.preventDefault();
                                   open_external_link(a); });
  a.textContent = '(license terms)';
  tr.appendChild( td.appendChild(a) );

  parentNode.appendChild(tr);
}

function add_licenses(license_list) {
  var ll = document.querySelector('table[id=license_list]');

  for (var i in license_list)
    add_one_license(ll, license_list[i]);
}

function get_license_list() {
  var basedir = '/usr/share/puavo-ltsp-client/restricted-packages';
  try {
    var software_directories = fs.readdirSync(basedir);
  } catch (ex) {
    alert(ex);
    return [];
  };

  var list = [];

  for (var i in software_directories) {
    var dir = software_directories[i];
    var dir_fullpath = basedir + '/' + dir;
    if (! fs.statSync(dir_fullpath).isDirectory())
      continue;

    var license_path = dir_fullpath + '/license.json';
    try {
      var license_info = JSON.parse(fs.readFileSync(license_path));
    } catch(ex) { alert(ex); continue; }

    if (license_info && license_info.name && license_info.url) {
      license_info.key = dir;
      list.push(license_info);
    } else {
      alert('License information was not in correct format in '
              + license_path);
    }
  }

  return list;
}

function hash_password(password, old_hashed_password, cb) {
  // if user did not provide a password,
  // use the password from old configuration
  if (password === '') { return cb(old_hashed_password); }

  var child = child_process.spawn('mkpasswd',
                                  [ '-m', 'sha-512', '-s' ]);
  child.stdin.end(password);

  var hashed_password = '';
  child.stdout.on('data',
                  function(buf) { hashed_password += buf.toString(); });
  child.stdout.on('end', function() {
                           if (!hashed_password) {
                             alert('Could not hash user password');
                           } else {
                             return cb(hashed_password.replace(/\n$/, ''));
                           }
                         });
}

function open_external_link(e) {
  var child = child_process.spawn('x-www-browser',
                                  [ e.href ],
                                  { detached: true, stdio: 'ignore' });
  child.unref();
}

function read_config() {
  var config;

  try {
    config = JSON.parse( fs.readFileSync(config_json_path) );
  } catch (ex) {
    if (ex.code !== 'ENOENT') {
      alert(ex);
      return false;
    } else {
      config = {
        allow_login: 'localusers',
        admins:      [],
        licenses:    {},
        local_users: [ { hashed_password: '', login: '', name: '', } ],
      };
    }
  }

  return config;
}

function set_form_values_from_config(config) {
  // allow_login
  [].forEach.call(document.querySelectorAll('input[name=allow_login'),
                  function(e) {
                    if (e.getAttribute('value') === config.allow_login)
                      e.setAttribute('checked', true); });

  // local_users
  for (var i in config.local_users) {
    var login = config.local_users[i].login;
    var name  = config.local_users[i].name;

    document.querySelector('input[name=localuser_' + i + '_login')
            .setAttribute('value', login);
    document.querySelector('input[name=localuser_' + i + '_name')
            .setAttribute('value', name);

    // check if user if found in the admins array
    if (config.admins.indexOf(login) >= 0) {
      document.querySelector('input[name=localuser_' + i + '_admin_rights')
              .setAttribute('checked', true);
    } else {
      document.querySelector('input[name=localuser_' + i + '_admin_rights')
              .removeAttribute('checked');
    }
  }

  // licenses
  var license_checkboxes
    = document.querySelectorAll('input[class=license_acceptance_checkbox]');
  [].forEach.call(license_checkboxes,
                  function(lc) {
                    var name = lc.getAttribute('name');
                    if (name in config.licenses && config.licenses[name]) {
                      lc.setAttribute('checked', true);
                    } else {
                      lc.removeAttribute('checked');
                    }
                  });
}

function write_config_json_and_exit(conf) {
  try {
    fs.writeFileSync(config_json_path,
                     JSON.stringify(conf) + "\n");
  } catch (ex) { alert(ex); throw(ex); }

  process.exit(0);
}

var old_config = read_config();
if (!old_config) { process.exit(1); }

add_licenses(get_license_list());

set_form_values_from_config(old_config);

// in the end print configuration data as json
document.querySelector('input[id=done_button]')
        .addEventListener('click',
                          function() { assemble_config_and_exit(old_config) });
