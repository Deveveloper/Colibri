json = require('json')
widget = require('widget')
app = require('Plugins.app')
device = require('Plugins.device')
jsonfunc = require('Plugins.json-func')
func = require('Plugins.func')
filesfunc = require('Plugins.files-func')
message = require('Plugins.message')
slider = require('Plugins.slider')
crypt = require('Plugins.crypt')

if platform == "Win" or env == "simulator" then
    tinyfiledialogs = require('plugin.tinyfiledialogs')
end
utf8 = require('plugin.utf8')

_Editor = require('Groups.Editor.interface')
_Menu = require('Groups.Menu.interface')
_Projects = require('Groups.Projects.projects')
_Registration = require('Groups.Registration.interface')
_SignUp = require('Groups.SignUp.interface')
_SignIn = require('Groups.SignIn.interface')
_Feed = require('Groups.Feed.interface')