// filepath: /C:/Users/42060/Desktop/Andy/coding/first_project/andy-docker/skel/app_service/init-mongo.js
db = db.getSiblingDB('admin'); // Connect to the 'admin' database

//db.createUser({
//  user: 'mongo_user',
//  pwd: 'mongo_pw',
//  roles: [{ role: 'readWrite', db: 'admin' }]
//});

db.test.insertMany([
  { value: '1' },
  { value: '2' },
  { value: '3' }
]);