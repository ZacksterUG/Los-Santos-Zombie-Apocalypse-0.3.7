#define RECORDING "sgt_soup3" //Имя файла с записью без расширения.
#define RECORDING_TYPE 1 //Тип записи: 1 на транспорте, и 2 пешком

#include <a_npc>
main(){}
public OnRecordingPlaybackEnd() StartRecordingPlayback(RECORDING_TYPE, RECORDING);

#if RECORDING_TYPE == 1
    public OnNPCEnterVehicle(vehicleid, seatid) StartRecordingPlayback(RECORDING_TYPE, RECORDING);
    public OnNPCExitVehicle() StopRecordingPlayback();
#else
    public OnNPCSpawn() StartRecordingPlayback(RECORDING_TYPE, RECORDING);
#endif
