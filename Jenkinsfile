
pipeline {
    agent any
    parameters {
        string(name: 'name_imagen', defaultValue: 'my-angular-app-to-apk', description: 'Nombre de la imagen')
        string(name: 'tag_imagen', defaultValue: 'latest', description: 'Etiqueta de la imagen')
    }
    environment {
        name_final = "${name_imagen}:${tag_imagen}"
    }
    stages {
        stage('Preparing') {
            steps {
                script {
                    sh '''
						mkdir -p output
						chmod -R 755 output						
                    '''
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    sh '''
                        docker build . -t ${name_imagen}:${tag_imagen} -o output --rm
                    '''
                }
            }
        }
        stage('Logs') {
            steps {
                script {
                    sh '''
						cat /var/lib/jenkins/jobs/demos/jobs/angular/jobs/demo-angular-nx-jenkins-docker/builds/${BUILD_NUMBER}/log >> log.txt
                    '''
                }
            }
        }		
    }
	post {
        always {
            archiveArtifacts artifacts: 'log.txt, output/**/*.apk', onlyIfSuccessful: true
        }
    }	
}
