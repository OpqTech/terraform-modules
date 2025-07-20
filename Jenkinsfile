pipeline {
   agent { label 'terraform' }

  options {
    disableConcurrentBuilds()
  }
  
  parameters {
      choice (name: 'ENV', description: 'ENV', choices: "vpc\nrds\neks")      
      choice (name: 'AWS_REGION', description: 'AWS_REGION', choices: "ap-south-1")
      string( defaultValue: '', name: 'AWS_ACCESS_KEY_ID', description: 'AWS_ACCESS_KEY_ID', trim: true )
      string( defaultValue: '', name: 'AWS_SECRET_ACCESS_KEY', description: 'AWS_SECRET_ACCESS_KEY', trim: true )
  }

  stages {
     stage('Prerquisites'){
       steps{
          sh """
            sudo apt-get update
            sudo apt-get install curl jq -y 
              if ! command -v aws > /dev/null; then
                  echo "AWS CLI not found. Installing AWS CLI..."
                  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 2> /dev/null
                  
                  dpkg-query -l unzip > /dev/null || sudo apt-get update && sudo apt-get -y install unzip
                  
                  unzip awscliv2.zip > /dev/null
                  sudo ./aws/install > /dev/null
                  rm -rf awscliv2.zip aws
                  echo "AWS CLI installed successfully."
              fi
          """
         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'awsCred']]) {
           sh """
               # Configure AWS CLI
               aws configure set aws_access_key_id \$AWS_ACCESS_KEY_ID
               aws configure set aws_secret_access_key \$AWS_SECRET_ACCESS_KEY
               aws configure set region ${params.AWS_REGION}
            """
         }
       }
     }

     stage('Format') {
       steps {
         dir("${WORKSPACE}") {
          sh '''
            cd $ENV
            terraform fmt
            echo "formating done........."
          '''
         }
       }
     }
    
     stage('Validate') {
       steps {
         dir("${WORKSPACE}" ) {
             sh '''
               cd $ENV
               sh init.sh
               terraform validate
               echo "TF Validate Done............."
             '''
         }
       }
     }
     stage('Lint') {
          steps {
            dir( "${WORKSPACE}" ) {
              sh '''
                # Use bash explicitly to avoid the 'pipefail' issue
                cd $ENV
                curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh > install_tflint.sh
                sed -i 's/unzip -u/unzip/g' install_tflint.sh
                bash install_tflint.sh  # Use bash instead of sh
                tflint --init
                tflint --force
                echo "Lint Check Done............."
              '''
            }
          }
        }


     stage('Trivy Sec Check') {
        steps {
            dir("${WORKSPACE}") {
                sh '''
                    cd $ENV
                    version=$(git ls-remote --refs --tags --sort="version:refname" https://github.com/aquasecurity/trivy | tail -1 | awk -F"/" '{print $3}')
                    trimversion=$(echo $version | sed 's/v//g')
                    echo $trimversion
                    trivyurl="https://github.com/aquasecurity/trivy/releases/download/${version}/trivy_${trimversion}_Linux-64bit.tar.gz"
                    echo $trivyurl
                    wget -O trivy.tar.gz "$trivyurl" && tar -zxvf trivy.tar.gz
                    # Make the trivy binary executable
                    chmod +x trivy
                    ./trivy -h
                    ./trivy config .
                '''
            }
        }
    }

     stage('Plan') {
       steps {
         dir( "${WORKSPACE}" ) {
             sh """
               cd ${ENV}
               chmod +x init.sh
               sh init.sh
               terraform plan -no-color -out '${ENV}.tfplan' -parallelism=50 -var-file="../terraform.tfvars"
             """
         }
       }
     }

     stage('Approve deploy') {
      steps {
        dir( "${env.checkoutdir}" ) {
          input message: 'Apply the plan ?'
        }
        }
      }

     stage('Apply') {
       steps {
        dir( "${WORKSPACE}" ) {
            sh """
            cd ${ENV}
            time terraform apply -no-color -parallelism=50 -input=false '${ENV}.tfplan'
            date
            """
        }
      }
    }
  }
}
