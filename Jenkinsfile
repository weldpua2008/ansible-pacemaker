properties([
        disableConcurrentBuilds(),
        parameters([
                string(defaultValue: '', description: '', name: 'branch')
        ]),
        pipelineTriggers([])
])


node("master") {

    stage('Checkout') {
        deleteDir()
        git url: 'https://github.com/jfrogdev/project-examples.git', branch: "${params.branch}"
    }

    stage('Lint-Test') {
        sh(script: 'molecule lint', returnStatus: true)
    }

    stage('Idempotency-Test') {
        sh(script: 'ansible-playbook -i tests/inventory tests/example-playbook.yml | grep -q "failed=0"', returnStatus: true)
        sh(script: 'ansible-playbook -i tests/inventory tests/example-playbook.yml | grep -q "changed=0.*failed=0"', returnStatus: true)
    }
}