
pipeline {
    agent any
    parameters {
        string(name: 'name_imagen', defaultValue: 'my-angular-app-to-apk', description: 'Nombre de la imagen')
        string(name: 'tag_imagen', defaultValue: 'latest', description: 'Etiqueta de la imagen')
    }
    environment {
        name_final = "${name_imagen}:${tag_imagen}"
		build_folder = "${JENKINS_HOME}/jobs/demos/jobs/angular/jobs/demo-angular-nx-jenkins-docker/builds/${BUILD_NUMBER}"
		log_folder = "${JENKINS_HOME}/jobs/demos/jobs/angular/jobs/demo-angular-nx-jenkins-docker/builds/${BUILD_NUMBER}"
		output_folder = "${JENKINS_HOME}/jobs/demos/jobs/angular/jobs/demo-angular-nx-jenkins-docker/builds/${BUILD_NUMBER}/output"
    }
    stages {
        stage('Preparing') {
            steps {
                script {
                    sh '''
						mkdir -p ${JENKINS_HOME}/jobs/demos/jobs/angular/jobs/demo-angular-nx-jenkins-docker/builds/${BUILD_NUMBER}/output
						chmod -R 755 output						
                    '''
                }
            }
        }
        stage('Build Docker') {
            steps {
                script {
                    sh '''
						pwd
                        docker build -t ${name_imagen}:${tag_imagen} -o ${output_folder} --rm .
						pwd
						ls -l						
                    '''
                }
            }
        }
        stage('Browse Result') {
            steps {
                script {
                    sh '''
                        cd ${output_folder}
						ls -l
                    '''
                }
            }
        }
        stage('Clean Docker') {
            steps {
                script {
                    sh '''
						df -h --total
                        docker system prune -a -f
                    '''
                }
            }
        }
        stage('Logs') {
            steps {
                script {
                    sh '''
						cat ${log_folder}/log >> log.txt
						
                    '''
                }
            }
        }		
    }
	post {
        always {
            archiveArtifacts artifacts: 'log.txt, **/*.apk', onlyIfSuccessful: true
        }
    }	
}
