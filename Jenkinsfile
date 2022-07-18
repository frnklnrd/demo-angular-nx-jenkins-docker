
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
        stage('build') {
            steps {
                script {
                    sh '''
						mkdir -p output
                        docker build . -t ${name_imagen}:${tag_imagen} -o output --rm
						cd output
						ls -l
						cd home
						ls -l
                    '''
                }
            }
        }
    }
}
