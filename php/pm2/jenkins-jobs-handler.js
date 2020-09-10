const http = require('http');
const childProcess = require('child_process');
const config = require('./config.js');

http.get(config.jenkinsApiUrl, {
    timeout: 10000
}, (res) => {
    const {statusCode} = res;

    if (statusCode !== 200) {
        console.error(`Request Failed. Status Code: ${statusCode}`)
        res.resume();
        return;
    }

    let rawData = '';

    res.on('data', (chunk) => {
        rawData += chunk;
    });

    res.on('end', () => {
        try {
            const parsedData = JSON.parse(rawData);

            if (parsedData.jobs.length !== 0) {
                return;
            }

            childProcess.execSync(`vendor/bin/install -r ${config.recipeName} -s jenkins-generate`, {
                cwd: '/var/www/spryker/releases/current'
            });
        } catch (e) {
            console.error(e.message);
        }
    });
}).on('error', (e) => {
    console.error(e.message);
});
