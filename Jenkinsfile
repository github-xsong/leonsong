pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'ghcr.io/github-xsong/leonsong'
        CONTAINER_NAME = 'blog-website'
        HOST_PORT = '80'
        CONTAINER_PORT = '80'
        GITHUB_CREDENTIALS = 'github-token'
        DEPLOY_SCRIPT = '/opt/deploy.sh'
    }
    
    stages {
        stage('自动化部署') {
            steps {
                script {
                    // 使用部署脚本进行部署
                    withCredentials([string(credentialsId: "${GITHUB_CREDENTIALS}", variable: 'GITHUB_TOKEN')]) {
                        sh '''
                            export GITHUB_TOKEN=$GITHUB_TOKEN
                            ${DEPLOY_SCRIPT}
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '🎉 部署成功！网站已更新到最新版本'
            // 可以添加通知，如发送邮件或 Slack 消息
        }
        failure {
            echo '❌ 部署失败，请检查日志'
            // 可以添加故障恢复逻辑
        }
        always {
            // 清理工作空间
            cleanWs()
        }
    }
} 