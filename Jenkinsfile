#!groovy

import groovy.transform.Field

@Field String email_to = 'kph@platinasystems.com'
@Field String email_cc = 'kph@platinasystems.com'
@Field String email_from = 'jenkins-bot@platinasystems.com'
@Field String email_reply_to = 'no-reply@platinasystems.com'

pipeline {
    agent any
    stages {
	stage('Checkout') {
	    steps {
		echo "Running build #${env.BUILD_ID} on ${env.JENKINS_URL}"
		checkout([$class: 'GitSCM', branches: [[name: '*/buildroot']],
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
		parallel (
		    "Build-example-amd64" : {
			sh 'make O=builds/example-amd64_defconfig example-amd64_defconfig'
			sh 'make O=builds/example-amd64_defconfig all'
		    },
		    "Build-platina-mk1" : {
			sh 'make O=builds/platina-mk1 platina-mk1_defconfig'
			sh 'make O=builds/platina-mk1 all'
		    },
		    "Build-platina-mk1-bmc" : {
			sh 'make O=builds/platina-mk1-bmc platina-mk1-bmc_defconfig'
			sh 'make O=builds/platina-mk1-bmc all'
		    }
		)
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
