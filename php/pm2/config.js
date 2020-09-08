const os = require('os');

function createJenkinsSlaveName() {
    const networkInterfaces = os.networkInterfaces();
    const networkAddress = networkInterfaces.eth0.find(networkAddress => networkAddress.family === 'IPv4');

    return `zed-worker-${networkAddress.address}`.replace(/\./g, '-');
}

exports.jenkinsApiUrl = `${process.env.JENKINS_URL}api/json?pretty=true`;
exports.jenkinsSlaveName = createJenkinsSlaveName();
exports.jenkinsUrl = process.env.JENKINS_URL;
exports.nodeConfig = `
<slave>
    <description></description>
    <remoteFS>/var/www/spryker/releases/current</remoteFS>
    <numExecutors>3</numExecutors>
    <mode>NORMAL</mode>
    <retentionStrategy class="hudson.slaves.RetentionStrategy$Always"/>
    <launcher class="hudson.slaves.JNLPLauncher"/>
    <nodeProperties/>
</slave>
`;
exports.pathToJenkinsCliJar = '/var/www/jenkins-cli.jar';
exports.pathToJenkinsSlaveJar = '/var/www/jenkins-salve.jar';
exports.pathToSpryker = '/var/www/spryker/releases/current';
exports.recipeName = process.env.RECIPE_NAME;
