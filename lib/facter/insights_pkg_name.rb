Facter.add(:insights_client_pkg) do
    confine :kernel => 'Linux'
    setcode do
       client_pkg = Facter::Core::Execution.execute('yum provides "/usr/bin/insights-client" | grep -m 1 -o insights-client')
       client_pkg = "redhat-access-insights" if client_pkg == ""
       client_pkg
    end
end

