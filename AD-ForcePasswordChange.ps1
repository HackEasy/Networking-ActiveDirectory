#        Th3 M4d_Sc13nT15t is here to stay...
#    We trust you have received teh usual lecture
#        from the local System Administrator. 
#   It usually boils down to these three things:
#  		#1) Respect the privacy of others.
#  		#2) Think before you type.
#  		#3) With great poewr comes great responsibility.


Get-ADUser -Filter * -SearchBase “OU=OUNAME,DC=DOMAIN,DC=COM” | Set-ADUser -ChangePasswordAtLogon:$true
