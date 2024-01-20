!constant ORG_NAME "Lottery Ticketz"

workspace {
    model {
        user = person "User"
        
        softwareSystem = softwareSystem "${ORG_NAME} Website" {
            webApp = container "Web App" "Number generator web application" "Python, Django" {
                user -> this "Access" "HTTPS"
            }
        }
        
        productionDeploy = deploymentEnvironment "Production" {
            vps = deploymentNode "${ORG_NAME} VPS" {
                reverseProxyServer = deploymentNode "Reverse Proxy" "" "Docker Container, Linux Alpine" {
                    nginxReverseProxy = infrastructureNode "Nginx Reverse Proxy" "Handles web requests and pass or redirect to the correct service" "Ngnix, HTTPS"  {
                    
                    }
                    
                }
                
                staticContentServer = deploymentNode "Static Web Content" "" "Docker Container, Linux Alpine" {
                    infrastructureNode "Static Files Server" "Serves public static files" "Nginx, HTTP" {
                        nginxReverseProxy -> this "Redirect /static requests to" "HTTP"
                    }
                    
                }
                
                webAppServer = deploymentNode "Web Application" "" "Docker Container, Linux Alpine" {
                    deploymentNode "Application Server" "" "Nginx, uwsgi, HTTP" {
                        nginxReverseProxy -> this "Pass the request to" "HTTP"
                        containerInstance webApp {
                        
                        }
                    }
                }
            }
        }
    }

    views {
        systemContext softwareSystem {
            include *
            autolayout lr
        }

        container softwareSystem {
            include *
            autolayout lr
        }
        
        deployment softwareSystem productionDeploy {
            include *
            autolayout lr
        }

        theme default
    }

}
