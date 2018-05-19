
if [ "$1" != "" ]
then

ng new --style scss $1
cd $1
ng g universal --app-id $1 --client-project $1
npm install --save\
 ts-loader\
 @nguniversal/module-map-ngfactory-loader\
 @nguniversal/express-engine\
 @nguniversal/common\
 webpack-cli

cd ..

cat client-template/app.server.module.ts > $1/src/app/app.server.module.ts 
cat client-template/tsconfig.server.json > $1/src/tsconfig.server.json
sed "s/APP_NAME/$1/g" client-template/server.ts > $1/server.ts
sed "s/APP_NAME/$1/g" client-template/prerender.ts > $1/prerender.ts
cat client-template/webpack.server.config.js > $1/webpack.server.config.js
sed "s/APP_NAME/$1/g" client-template/package.json > $1/package.json
cat client-template/static.paths.ts > $1/static.paths.ts
cd $1

rm -rf .git READNE.md client-template
cd ..
mv web-template $1
cd $1
mv $1 $1'.client'

echo "\
cd $(ls | grep .client)\
&& mv dist dist_\
&& npm run build:prerender\
&& app_name=\
&& mv dist_//.git dist/\
&& rm -rf dist_\
&& cd dist/\
&& (git add .; git commit -m 'update origin master'; git push origin master)
" > build-client.sh

fi