const request = require('request');
const express = require('express');
const bodyParser = require('body-parser');

api = express();
api.use(bodyParser.json());
api.use(bodyParser.urlencoded({ extended: false }));

api.get('/old/:user', function(req, res) {
  getInventory(req.params.user, function(json) {
    res.json(json);
  });
});

api.get('/inventory/:user', function(req, res) {
  newInventory(req.params.user, function(json) {
    res.json(json);
  });
});

api.all('/webhook/sentry', function(req, res) {
  request.post('https://discordapp.com/api/webhooks/253670100203339777/mMuea5KNbzfwCUFcoHRAOtaM2kBoiUzdgKJfHmUYifXCyp519-SnbSxSlhybMSmjkmoI', {form: {
    content:  '```markdown\n' +
              '[Type]: ' + req.body.event.metadata.type + '\n' +
              '[Message]: ' + req.body.message + '\n' +
              '[Issue URL]: ' + req.body.url + '\n' +
              '[Error URL]: ' + req.body.event['sentry.interfaces.Http'].url + '```'
  }}, function(err, resp, body) {
    console.log(body);
  });
  res.send('lol');
});

api.listen(80, function() {});

function newInventory(roblox_user_id, callback) {
  var types = [8,18,19,41,42,43,44,45,46,47];
  var left = types.length;
  var inventory = [];
  for (var i = 0; i < types.length; i++) {
    getPage(types[i]);
  }

  function getPage(type, cursor=null, tries=1) {~
    request.get('https://inventory.roblox.com/v1/users/' + roblox_user_id + '/assets/collectibles?limit=100&assetType=' + type.toString() + ((cursor==null)?'':'&cursor=' + cursor), {timeout:5000}, function(err, resp, body) {
      console.log(type);
      if(err) { return ((tries == 3)?complete(type):getPage(type, cursor, tries+1)); }
      json = JSON.parse(body);
      if(json.errors) { return complete(type); }
      if(json.nextPageCursor == null) { return push(json.data, () => { complete(type); }) }
      push(json.data, () => { getPage(type, json.nextPageCursor); });
    });
  }

  function push(json, cb) {
    left_to_process = json.length;

    if(!left_to_process) { return cb(); }

    json.forEach(function(item) {
      inventory.push({
        name: item.name,
        rap: item.recentAveragePrice,
        uaid: item.userAssetId,
        link: 'https://www.roblox.com/catalog/' + item.assetId + '/Aer-Draco',
        id: item.assetId
      });
      if(!--left_to_process) {
        console.log('callback');
        cb();
      }
    });
  }

  function complete(type) {
    if(!--left) {
      callback(inventory);
    }
  }
}
