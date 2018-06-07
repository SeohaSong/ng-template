(
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

        cat script/app.server.module.ts > $1/src/app/app.server.module.ts 
        cat script/tsconfig.server.json > $1/src/tsconfig.server.json
        sed "s/APP_NAME/$1/g" script/server.ts > $1/server.ts
        sed "s/APP_NAME/$1/g" script/prerender.ts > $1/prerender.ts
        cat script/webpack.server.config.js > $1/webpack.server.config.js
        sed "s/APP_NAME/$1/g" script/package.json > $1/package.json
        cat script/static.paths.ts > $1/static.paths.ts

        rm -rf .git README.md script
        cd ..
        mv template.client $1'.client'
        cd $1'.client'

        echo \
"cd $1.client\\
&& mv dist dist_\\
&& npm run build:prerender\\
&& mv dist_/$1/.git dist/$1\\
&& rm -rf dist_\\
&& cd dist/$1\\
&& (git add .; git commit -m 'update origin master'; git push origin master)"\
        > build.sh

        rm -rf init.sh

    fi
)

if [ -d "$1" ]
then
    cd .
fi