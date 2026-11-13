#!../../bin/linux-x86_64/mcaDanteApp

#- SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS


< envPaths

cd "${TOP}"

# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in this build from dxpApp
#dbLoadDatabase("$(DANTE)/dbd/mcaDanteApp.dbd")
#mcaDanteApp_registerRecordDeviceDriver(pdbbase)

# The search path for database files

epicsEnvSet ("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")

# Prefix for all records
epicsEnvSet("PREFIX", "Dante:")
# Prefix for Single channel
epicsEnvSet("PREFIX_CH", "dante1:")
# The port name for the detector
epicsEnvSet("PORT",   "DANTE1")
# The queue size for all plugins
epicsEnvSet("QSIZE",  "20")
# The maximum image width; used to set the maximum size for row profiles in the NDPluginStats plugin
epicsEnvSet("XSIZE",  "1024")
# The maximum image height; used to set the maximum size for column profiles in the NDPluginStats plugin
epicsEnvSet("YSIZE",  "1024")
# The maximum number of time series points in the NDPluginStats plugin
#epicsEnvSet("NCHANS", "2048")
epicsEnvSet("NCHANS", "4096")
# The maximum number of frames buffered in the NDPluginCircularBuff plugin
epicsEnvSet("CBUFFS", "500")
# The maximum number of threads for plugins which can run in multiple threads
epicsEnvSet("MAX_THREADS", "8")
# The maximum number of channels in the MCA records
#epicsEnvSet("MCA_CHANS", "2048")
epicsEnvSet("MCA_CHANS", "4096")
# The maximum number of points in the ADC trace waveform records
epicsEnvSet("TRACE_LEN", "16384")
# The search path for database files
# The search path for database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")


# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in this build from dxpApp
dbLoadDatabase "$(DANTE)/dbd/mcaDanteApp.dbd"
mcaDanteApp_registerRecordDeviceDriver pdbbase


# DanteConfig(portName, ipAddress, numDetectors, maxBuffers, maxMemory)
#DanteConfig("$(PORT)", 164.54.160.186, 8, 0, 0)
DanteConfig("$(PORT)", 100.100.0.31, 3, 0, 0)

dbLoadTemplate($(DANTE)/db/"dante8.substitutions", "P=$(PREFIX), NCHAN=$(MCA_CHANS), TRACE_LEN=$(TRACE_LEN)")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd

set_requestfile_path("$(DANTE)/danteApp/Db")
set_requestfile_path("$(MCA)/mcaApp/Db")

asynSetTraceIOMask($(PORT),0,ESCAPE)
asynSetTraceMask($(PORT),0,ERROR|WARNING)

iocInit

#seq danteMED "P=$(PREFIX), DANTE=dante, MCA=mca, N_DETECTORS=8")
#seq danteMED "P=$(PREFIX), DANTE=dante, MCA=mca, N_DETECTORS=3")
seq danteMED "P=$(PREFIX), DANTE=dante, MCA=mca, N_DETECTORS=3"

### Start up the autosave task and tell it what to do.
# Save settings every thirty seconds
#create_monitor_set("auto_settings.req", 30, "P=$(PREFIX), R=dante:, M=mca1")
#create_monitor_set("auto_settings.req", 30, "P=$(PREFIX), R=dante:, M=mca2")

# Wait 5 seconds for all records with PINI=YES to process
epicsThreadSleep(5)

# Enable downloading configurations
dbpf("$(PREFIX)dante:EnableConfigure", "Enable")

# There is a problem with the GatingMode record.
# Even though it has PINI=YES and has already processed and written the value to the Dante,
# the value appears to have been changed, and it need to be processed again.  
# This needs to be tracked down.
dbpf("$(PREFIX)dante:GatingMode.PROC", "1")

# Fix the MCA CHannels to 4096
dbpf("$(PREFIX)dante:NumMCAChannels", "4096")
# Increase the Poll Time
dbpf("$(PREFIX)dante:PollTime", "0.02")
epicsThreadSleep(0.2)

# Parametri custom dante1
dbpf("$(PREFIX)$(PREFIX_CH)FastPeakingTime","0.096")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)FastThreshold","1.52")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)FastFlatTopTime","0.01")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)PeakingTime","2.976")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)MaxPeakingTime","0")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)FlatTopTime","0.05")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)EnergyThreshold","0.85")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)BaselineThreshold","0.85")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)MaxRiseTime","0.244")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)ResetRecoveryTime","2.4")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)ZeroPeakFreq	","10000")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)BaselineSamples","70")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)Gain","1")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)AnalogOffset","100")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)BaseOffset","70")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)ResetThreshold","1000")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)TimeConstant","0")
epicsThreadSleep(0.2)
dbpf("$(PREFIX)$(PREFIX_CH)MaxEnergy","50")
epicsThreadSleep(0.2)
