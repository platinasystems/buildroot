#!groovy

import groovy.transform.Field

@Field String email_to = 'sw@platinasystems.com'
@Field String email_cc = 'kph@platinasystems.com'
@Field String email_from = 'jenkins-bot@platinasystems.com'
@Field String email_reply_to = 'no-reply@platinasystems.com'

pipeline {
    agent any
    stages {
	stage('Checkout') {
	    steps {
		echo "Running build #${env.BUILD_ID} on ${env.JENKINS_URL}"
		checkout([$class: 'GitSCM', branches: [[name: '*/platina-2017.02']],
		    doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [],
		    userRemoteConfigs: [[url: 'https://github.com/platinasystems/buildroot.git']]])
	    }
	}

	stage('Prepare') {
	    steps {
		echo 'Cleaning up from previous builds'
		sh 'make distclean'
		sh 'rm -rf builds'
	    }
	}

	stage('Build') {
	    steps {
	    sh 'git fetch origin'
	    sh 'git checkout remotes/origin/platina-2017.02'
	    sh '[ -f Dockerfile ] && docker build -t platina-buildroot . || true'
	    }
	}
    }

    post {
	success {
	    mail body: "buildroot build ok: ${env.BUILD_URL}",
		from: email_from,
		replyTo: email_reply_to,
		subject: 'GOES buildroot build ok',
		cc: email_cc,
		to: email_to
	}
	failure {
	    mail body: "buildroot build error: ${env.BUILD_URL}",
		from: email_from,
		replyTo: email_reply_to,
		subject: 'GOES buildroot BUILD FAILED',
		cc: email_cc,
		to: email_to
	}
    }
}
