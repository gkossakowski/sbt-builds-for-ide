# Warning: THIS FILE IS BEING USED FOR INTEGRATION WITH THE SCALA-IDE TEAM
#          Pleases do not modify without contacting them.
# Nighlty job: https://jenkins-dbuild.typesafe.com:8499/job/sbt-0.13.x-nightly-for-ide-on-scala-2.10.x
{
  // Variables that may be external.  We have the defaults here.
  vars: {
    scala-version: "2.10.4-SNAPSHOT"
    scala-version: ${?SCALA_VERSION}
    publish-repo: "http://private-repo.typesafe.com/typesafe/ide-2.10"
    publish-repo: ${?PUBLISH_REPO}
    sbt-version: "0.13.2-M1"
    sbt-version: ${?SBT_VERSION}
    sbt-tag: "v"${vars.sbt-version}
    sbt-tag: ${?SBT_TAG}
  }
  build: {
    "projects":[
      {
        name:  "scala-lib",
        system: "ivy",
        uri:    "ivy:org.scala-lang#scala-library;"${vars.scala-version}
        set-version: ${vars.scala-version}
      }, {
        name:  "scala-compiler",
        system: "ivy",
        uri:    "ivy:org.scala-lang#scala-compiler;"${vars.scala-version}
        set-version: ${vars.scala-version}
      }, {
        name:  "scala-actors",
        system: "ivy",
        uri:    "ivy:org.scala-lang#scala-actors;"${vars.scala-version}
        set-version: ${vars.scala-version}
      }, {
        name:  "scala-reflect",
        system: "ivy",
        uri:    "ivy:org.scala-lang#scala-reflect;"${vars.scala-version}
        set-version: ${vars.scala-version}
      }, {
        name:   "scalacheck",
        system: "ivy",
        uri:    "ivy:org.scalacheck#scalacheck_2.10;1.10.1"
      }, {
        name:   "sbinary",
        uri:    "git://github.com/harrah/sbinary.git#master"
        extra: { projects: ["core"] }
      }, {
        name:   "sbt",
        uri:    "git://github.com/sbt/sbt.git#"${vars.sbt-tag}
        extra: {
          projects: ["compiler-interface",
                     "classpath","logging","io","control","classfile",
                     "process","relation","interface","persist","api",
                     "compiler-integration","incremental-compiler","compile","launcher-interface"
                    ],
          run-tests: false,
          sbt-version: "0.13.1"
        }
      }, {
        name:   "sbt-republish",
        uri:    "http://github.com/typesafehub/sbt-republish.git#master",
        set-version: ${vars.sbt-version}"-on-"${vars.scala-version}"-for-IDE-SNAPSHOT"
      }, {
        name:   "zinc",
        uri:    "https://github.com/typesafehub/zinc.git#master"
      }
    ],
    options:{cross-version:standard},
  }
  options: {
    deploy: [
      {
        uri=${?vars.publish-repo},
        credentials="/home/jenkinsdbuild/dbuild-josh-credentials.properties",
        projects:["sbt-republish"]
      }
    ]
    notifications: {
      send:[{
        projects: "."
        send.to: "qbranch@typesafe.com"
        when: bad
      },{ 
        projects: "."
        kind: console
        when: always
      }]
      default.send: {
        from: "jenkins-dbuild <antonio.cunei@typesafe.com>"
        smtp:{
          server: "psemail.epfl.ch"
          encryption: none
        }
      }
    }
  }
}
