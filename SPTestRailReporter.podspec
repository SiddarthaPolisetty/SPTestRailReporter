Pod::Spec.new do |s|

    s.name         = "SPTestRailReporter"
    s.version      = "0.0.1"
    s.summary      = "SPTestRailReporter is the missing iOS Framework that automagically performs TestRail Reporting."
    s.description  = <<-DESC
                    SPTestRailReporter performs almost all CRUD operations on all entities supported by TestRail api v2. The following documentation helps you onboard SPTestRailReporter.
                   DESC

    s.homepage     = "https://siddarthapolisetty.github.io/SPTestRailReporter/"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Siddartha Polisetty" => "siddarthpolishetty@yahoo.com" }
    s.social_media_url   = "https://www.linkedin.com/in/siddarthapolisetty"
    s.platform     = :ios, "8.0"
    s.source       = { :git => "https://github.com/SiddarthaPolisetty/SPTestRailReporter.git", :tag => "#{s.version}" }
    s.source_files  = "SPTestRailReporter"
    s.requires_arc = true
    s.dependency 'NSData+Base64', '1.0.0'
    s.dependency 'AFNetworking', '2.5.4'
    s.dependency 'JSONModel', '1.2.0'

end
