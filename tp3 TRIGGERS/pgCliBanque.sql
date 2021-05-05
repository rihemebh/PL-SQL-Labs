create table clibanque(
	idCli INT,
	nomCli VARCHAR(50),
	idConjoint INT,
	constraint cliPK primary key(idCli),
	constraint cliFK foreign key(idConjoint) references clibanque(idCli)
)