pipeline
{
    agent any
    stages{
        stage("checkout code")
        {
            steps
            {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/swathi1498/Petclinic-Application.git']])
            }
        }
        stage("sonar-code analysis")
         {
             steps
             {
                 withSonarQubeEnv("sonar-server")
                 {
                     sh "mvn verify sonar:sonar"
                 }
             }
         }
         stage("quality gate")
         {
             steps
             {
                timeout(time: 5, unit: 'MINUTES')
                {
                    waitForQualityGate abortPipeline: true
                }
             }
         }
         stage("Build")
        {
            steps
            {
                sh 'mvn clean package'
            }
            post
            {
                success{
                    echo 'now archiving'
                    archiveArtifacts artifacts: 'target/*.jar', followSymlinks: false
                }
            }
         }
         stage("nexus artifactory upload")
         {
             steps
             {
                 nexusArtifactUploader artifacts: [[artifactId: '$BUILD_TIMESTAMP', classifier: '', file: 'target/spring-petclinic-3.5.0-SNAPSHOT.jar', type: 'JAR']], credentialsId: '2c6be045-e6ea-41fd-adc4-714b288c5306', groupId: 'dev', nexusUrl: '172.31.87.125:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'pet-cliniccc', version: '3.5.0-$BUILD_ID'
             }
         }
         stage("Building docker image")
         {
             steps
             {
                 sh 'docker build -t kumarltd/new-petclinic:latest .'
             }
         }
         stage("pushing to docker hub")
         {
             steps
             {
                 withDockerRegistry(credentialsId: 'fdfa81cc-7d53-4ace-94df-566e5683583b', url: 'https://index.docker.io/v1/')
                 {
                     sh 'docker push kumarltd/new-petclinic:latest'
                 }
             }
         }
         stage("deploying with k8s")
         {
             steps
             {
                 sh 'kubectl apply -f k8s/ -n testing'
             }
         }
    }
}
