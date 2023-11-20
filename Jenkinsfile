pipeline {

    agent {
        label 'jenkins-agent'
    }
    environment {
        DRUPAL_VARS = credentials('drupal-vars')
        MS_ENV = credentials('ms-env')
    }

    stages {

        stage('Scanning the microservice code') {
            steps {
                // Lancement de l'app
                sh '''
                    cd python-ms/
                    trivy fs --scanners config --format template --template "@/home/jenkins/html.tpl" -o /home/jenkins/code-scan.html .
                '''
                echo "Microservice code scanned sucessfully"
            }
        }

        stage('Creating environment variables') {
            steps {
                sh('cp -f $DRUPAL_VARS ansible-drupal/group_vars/all.yaml && chmod 644 ansible-drupal/group_vars/all.yaml')
                sh('cp -f $MS_ENV python-ms/.env && chmod 644 python-ms/.env')
                echo "Environement variables created"
            }
        }

        stage('Drupal architecture creation') {
            steps {
                sh '''
                    cd terraform-drupal/
                    terraform init
                    terraform apply --auto-approve
                '''
                echo "Drupal aws architecture is ready"
            }
        }

        stage('Drupal launch') {
            steps {
                //  Lancement drupal.
                sh '''
                    cd ansible-drupal/
                    ansible-playbook playbook.yaml
                '''
                echo "Drupal is ready"
            }
        }

        stage('Microservice architecture creation') {
            steps {
                //  Lancement drupal.
                sh '''
                    cd terraform-ms/
                    terraform init
                    terraform apply --auto-approve
                '''
                echo "Microservice aws architecture is ready"
            }
        }

        stage('Application tests') {
            steps {
                timeout(10) {
                    waitUntil {
                        script {
                            try {
                                def response = httpRequest(
                                    httpMode: 'GET',
                                    ignoreSslErrors: true,
                                    url: 'https://drupal.kevin-billerach.me'
                                )
                                return (response.status == 200)
                            }
                            catch (exception) {
                                return false
                            }
                        }
                    }
                }
                try {
                    sh '''
                        cd python-ms/
                        python3 -m venv myenv
                        . ./myenv/bin/activate
                        pip3 install -r requirements.txt
                        flake8 --ignore=E402 --exclude=myenv .
                        python3 test_add_article.py
                        python3 test_delet_article.py
                    '''

                    echo "Tests passed successfully"
                    echo "Now creating the microservice image..."

                    sh '''
                        cd python-ms/
                        aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 019050461780.dkr.ecr.eu-west-1.amazonaws.com
                        docker build -t kebi-ecr .
                        docker tag kebi-ecr:latest 019050461780.dkr.ecr.eu-west-1.amazonaws.com/kebi-ecr:latest
                        docker push 019050461780.dkr.ecr.eu-west-1.amazonaws.com/kebi-ecr:latest
                    '''
                    echo "Image is ready to use"
                }
                catch (exception) {
                    currentBuild.result = 'UNSTABLE'
                    echo "Tests failed. New image won't be created."
                    echo "Last known is being deployed instead..."
                }
                

            }
        }


        stage('Microservice deployment on EKS') {
            steps {
                // Lancement de l'app
                sh '''
                    cd kubernetes-ms/
                    kubectl apply -f .
                '''
                echo "Microservice deployed sucessfully"
            }
        }

        // stage('Scanning the microservice container') {
        //     steps {
        //         // Lancement de l'app
        //         sh '''
        //             cd /home/jenkins
        //             trivy image --timeout 10m --format template --template "@html.tpl" -o image-scan.html microservice
        //         '''
        //         echo "Microservice container scanned sucessfully"
        //     }
        // }

        // stage('Deployment') {
        //     steps {
        //         // Lancement de l'app
        //         sh '''
        //             cd python/
        //             docker compose up -d
        //         '''
        //         echo "Microservice deployed sucessfully"
        //     }
        // }

    }
    post {
        failure {
            cleanWs()
            git branch: 'last-stable', credentialsId: 'github_access', url: 'https://github.com/pittour/projet-C.git'
            sh('cp -f $DRUPAL_VARS ansible-drupal/group_vars/all.yaml && chmod 644 ansible-drupal/group_vars/all.yaml')
            sh('cp -f $MS_ENV python-ms/.env && chmod 644 python-ms/.env')
            sh '''
                cd terraform-drupal/
                terraform init
                terraform apply --auto-approve
                cd ../ansible-drupal
                ansible-playbook playbook.yaml
                cd ../terraform-ms
                terraform init
                terraform apply --auto-approve
                cd ../kubernetes-ms
                kubectl apply -f .
            '''
            echo "Rollbacked to the last stable version"
        }

        unstable {
            echo "Deployment of new microservice version failed. The microservice version has been set to the last known stable version"
        }

        success {
            publishHTML target : [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: '/home/jenkins',
                reportFiles: 'code-scan.html',
                reportName: 'Security Scan',
                reportTitles: 'Code scan'
            ]

            withCredentials([gitUsernamePassword(credentialsId: 'github_access', gitToolName: 'Default')]) {
                sh '''
                    git push --force origin HEAD:last-stable
                '''
            }
        }

        always {
            timeout(10) {
                    waitUntil {
                        script {
                            try {
                                def response = httpRequest(
                                    httpMode: 'GET',
                                    ignoreSslErrors: true,
                                    url: 'https://ms.kevin-billerach.me'
                                )
                                return (response.status == 200)
                            }
                            catch (exception) {
                                return false
                            }
                        }
                    }
                }
            sh '''
                cd /home/jenkins/apache-jmeter-5.6.2/bin
                /home/jenkins/apache-jmeter-5.6.2/bin/jmeter -j jmeter.save.saveservice.output_format=xml -n -t charge.jmx -l report.jtl
            '''
            perfReport '/home/jenkins/apache-jmeter-5.6.2/bin/report.jtl'
        }
    }
}
