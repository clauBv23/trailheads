trigger MaintenanceRequest on Case (before update) {
  MaintenanceRequestHelper.run(Trigger.oldMap,Trigger.newMap);
}