const childProcess = require('child_process');
const config = require('./config.js');
const fs = require('fs');
const http = require('http');

function startJenkinsSlave() {
    const spawnedChildProcess = childProcess.spawnSync(
        '/usr/bin/java',
        ['-Xms64m', '-Xmx128m', '-jar', config.pathToJenkinsSlaveJar, '-jnlpUrl', `${config.jenkinsUrl}computer/${config.jenkinsSlaveName}/slave-agent.jnlp`]
    );

    if (spawnedChildProcess.status !== 0) {
        console.error(Buffer.from(spawnedChildProcess.stderr).toString());
    }
}

function createJenkinsNode() {
    let spawnedChildProcess = childProcess.spawnSync(
        '/usr/bin/java',
        ['-jar', config.pathToJenkinsCliJar, '-s', config.jenkinsUrl, 'get-node', config.jenkinsSlaveName]
    );

    if (spawnedChildProcess.status !== 0) {
        spawnedChildProcess = childProcess.spawnSync(
            '/usr/bin/java',
            ['-jar', config.pathToJenkinsCliJar, '-s', config.jenkinsUrl, 'create-node', config.jenkinsSlaveName],
            {
                input: config.nodeConfig
            }
        );
    }

    if (spawnedChildProcess.status !== 0) {
        console.error(Buffer.from(spawnedChildProcess.stderr).toString());
        return;
    }

    spawnedChildProcess = childProcess.spawnSync(
        '/usr/bin/java',
        ['-jar', config.pathToJenkinsCliJar, '-s', config.jenkinsUrl, 'offline-node', '']
    );

    if (spawnedChildProcess.status !== 0) {
        console.error(Buffer.from(spawnedChildProcess.stderr).toString());
    }
}

function downloadJar(from, to) {
    return new Promise((resolve, reject) => {
        const writeStream = fs.createWriteStream(to);

        writeStream.on('finish', () => {
            resolve('All writes are now complete.');
        }).on('error', (e) => {
            reject(e);
        })

        http.get(from, (response) => {
            response.pipe(writeStream);
        }).on('error', (e) => {
            reject(e);
        });
    });
}

function pingJenkins() {
    return new Promise((resolve, reject) => {
        http.get(config.jenkinsApiUrl, {
            timeout: 5000
        }, (response) => {
            const {statusCode} = response;

            if (statusCode !== 200) {
                console.error(`Request Failed. Status Code: ${statusCode}`);
                response.resume();
                reject();
                return;
            }

            resolve();
        }).on('error', (e) => {
            console.error(e.message);
            reject();
        });
    });
}

(async () => {
    let isJenkinsAlive = false;

    while (!isJenkinsAlive) {
        try {
            await pingJenkins()
            isJenkinsAlive = true;
        } catch (e) {
            console.error(e.message);
        }

    }

    await downloadJar(`${config.jenkinsUrl}/jnlpJars/slave.jar`, config.pathToJenkinsSlaveJar);
    await downloadJar(`${config.jenkinsUrl}/jnlpJars/jenkins-cli.jar`, config.pathToJenkinsCliJar);

    createJenkinsNode();
    startJenkinsSlave();
})();
