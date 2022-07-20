
pipeline {
    agent any
    parameters {
        string(name: 'name_image', defaultValue: 'angular-app-to-apk', description: 'Nombre de la imagen')
        string(name: 'tag_image', defaultValue: 'latest', description: 'Etiqueta de la imagen')
    }
    environment {
        name_final = "${name_image}:${tag_image}"
        name_container = "${name_image}-${tag_image}-container"

		working_folder = "${WORKSPACE}"
		job_folder = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}"
		build_folder = "${JENKINS_HOME}/jobs/demos/jobs/angular/jobs/demo-angular-nx-jenkins-docker/builds/${BUILD_NUMBER}"
		log_folder = "${JENKINS_HOME}/jobs/demos/jobs/angular/jobs/demo-angular-nx-jenkins-docker/builds/${BUILD_NUMBER}"
		output_folder = "output/${BUILD_NUMBER}"
    }
    stages {
        stage('Clean Container') {
            when {
                expression {
                    DOCKER_EXIST = sh(returnStdout: true, script: 'echo "$(docker ps -q --filter name=${name_container})"').trim()
                    return  DOCKER_EXIST != ''
                }
            }
            steps {
                script {
                    sh '''
                        docker stop ${name_container}
                        docker rm -f ${name_container}
                    '''
                }
            }
        }	
        stage('Clean Image') {
            when {
                expression {
                    DOCKER_EXIST = sh(returnStdout: true, script: 'echo "$(docker images -q --filter reference=${name_image})"').trim()
                    return  DOCKER_EXIST != ''
                }
            }
            steps {
                script {
                    sh '''
                        docker rmi -f ${name_final}
                    '''
                }
            }
        }	
        stage('Build Docker') {
            steps {
                script {
                    sh '''
						docker build --rm -t ${name_final} .						
                    '''
                }
            }
        }
        stage('Output') {
            steps {
                script {
                    sh '''
						mkdir -p ${output_folder}
						
						chown -R jenkins:jenkins ${output_folder}
						
						chmod -R 755 ${output_folder}
						
						docker container create -i -t --name ${name_container} ${name_final}
						
						docker cp ${name_container}:/app-debug.apk ${output_folder}/app-debug-${tag_image}-${BUILD_NUMBER}.apk
                    '''
                }
            }
        }
        stage('Clean Docker') {
            steps {
                script {
                    sh '''
						df -h --total

						docker rm -f ${name_container}
						
						docker rmi -f ${name_final}

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
            archiveArtifacts artifacts: 'log.txt, ${output_folder}/app-debug-*.apk', onlyIfSuccessful: true
        }
    }	
}
