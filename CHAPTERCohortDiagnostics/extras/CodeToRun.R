# Sys.setlocale("LC_ALL", "Korean")
library(CHAPTERCohortDiagnostics)

# Optional: specify where the temporary files (used by the Andromeda package) will be created:
options(andromedaTempFolder = "s:/andromedaTemp")

# Maximum number of cores to be used:
maxCores <- parallel::detectCores()

# The folder where the study intermediate and result files will be written:
outputFolder <- "c:/CHAPTERCohortDiagnostics"

# Details for connecting to the server:
# See ?DatabaseConnector::createConnectionDetails for help
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "postgresql",
                                                                server = "some.server.com/ohdsi",
                                                                user = "joe",
                                                                password = "secret")

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "cdm_synpuf"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "scratch.dbo"
cohortTable <- "my_study_cohorts"

# Some meta-information that will be used by the export function:
databaseId <- "Synpuf"
databaseName <- "Medicare Claims Synthetic Public Use Files (SynPUFs)"
databaseDescription <- "Medicare Claims Synthetic Public Use Files (SynPUFs) were created to allow interested parties to gain familiarity using Medicare claims data while protecting beneficiary privacy. These files are intended to promote development of software and applications that utilize files in this format, train researchers on the use and complexities of Centers for Medicare and Medicaid Services (CMS) claims, and support safe data mining innovations. The SynPUFs were created by combining randomized information from multiple unique beneficiaries and changing variable values. This randomization and combining of beneficiary information ensures privacy of health information."

# For some database platforms (e.g. Oracle): define a schema that can be used to emulate temp tables:
options(sqlRenderTempEmulationSchema = NULL)

CHAPTERCohortDiagnostics::execute(
        connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        verifyDependencies = TRUE,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription
)

CohortDiagnostics::preMergeDiagnosticsFiles(dataFolder = outputFolder)

CohortDiagnostics::launchDiagnosticsExplorer(dataFolder = outputFolder)


# Upload the results to the OHDSI SFTP server:
# privateKeyFileName <- ""
# userName <- ""
# CHAPTERCohortDiagnostics::uploadResults(outputFolder, privateKeyFileName, userName)
