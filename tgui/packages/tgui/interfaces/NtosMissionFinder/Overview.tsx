import { useBackend } from "../../backend";
import { Section, Stack, Button } from "../../components";
import { MissionPlayerData, NtosMissionFinderData } from "../NtosMissionFinder";
import { InviteReceived } from "./InviteReceived";
import { InviteSent } from "./InviteSent";

function IsEveryoneReady(playersList: MissionPlayerData[]): boolean {
	var toReturn = true;
	playersList.forEach(player => {
		if (player.player_isready != "Ready")
			toReturn = false;
	});
	return toReturn;
}

export const Overview = () => {
	const { act, data } = useBackend<NtosMissionFinderData>();

	const {
		user,
		currentmissionData,
		invitations = [],
		vehicle
	} = data;

	return (
		<Section>
			<Stack align="baseline">
				<Stack.Item grow bold>
					Welcome, {user}
				</Stack.Item>
			</Stack>
			<Stack>
				<Stack.Item grow bold>
					{
						currentmissionData ?
							"Mission Information:" :
							"You are currently not enlisted in a mission"
					}
				</Stack.Item>
			</Stack>
			<Stack>
				<Stack.Item grow bold>
					Your mission:
					{
						currentmissionData ?
							currentmissionData.mission_name +
							"\nDifficulty: " + currentmissionData.mission_difficulty +
							"\nType: " + currentmissionData.mission_type +
							"\nHost" + currentmissionData.mission_hostername +
							"\nStatus: " + (currentmissionData.mission_started ? (currentmissionData.mission_completed ? "Completed" : "Ongoing") : "Awaiting initiation")
							:
							"N/A"
					}

				</Stack.Item>

				<Stack.Item grow bold>

					{
						currentmissionData
							? vehicle && vehicle.vehicle_name
								? "Your assigned vehicle: " + vehicle.vehicle_name
								: "You have no vehicle assigned yet."
							: null
					}

					{
						currentmissionData && currentmissionData.mission_hostername == user && currentmissionData.mission_started != true
							? vehicle && vehicle.vehicle_name
								? <Button
									bold
									children="Relinquish Vehicle"
									onClick={() =>
										act('MF_abandonvehicle', {

										})
									}
								/>
								: <Button
									bold
									children="Requisiton Vehicle"
									onClick={() =>
										act('MF_getvehicle', {

										})
									}
								/>
							: null
					}
					{
						currentmissionData && currentmissionData.mission_started == false ?
							<Button
								bold
								children="Leave Mission"
								onClick={() =>
									act('MF_leavegroup', {
										mission: currentmissionData.mission_name
									})
								}
							/> :
							null
					}
				</Stack.Item>

			</Stack>
			<Stack>
				<Stack.Item grow={1} basis={0}>
					{
						currentmissionData?.mission_list_players?.map((player) =>
						(
							player.player_name + " - " + player.player_isready
						))
					}
				</Stack.Item>
			</Stack>
			<Stack>
				<Stack.Item>
					{
						currentmissionData?.mission_list_players ?
							IsEveryoneReady(currentmissionData.mission_list_players) ?
								<Button
									bold
									children="Start Mission"
									onClick={() =>
										act('MF_startmission', {

										})
									}
								/>
								: "Not everyone is ready yet"
							:
							null
					}
				</Stack.Item>
			</Stack>
			<Stack>
				{
					currentmissionData ? "Active invites to contractors to join the current mission: " : null
				}
				{
					currentmissionData && currentmissionData.mission_started ?
						//Mission objectives list

						currentmissionData.mission_completed ?
							IsEveryoneReady(currentmissionData.mission_list_players) ?
								<Button
									bold
									children="Return from mission"
									onClick={() =>
										act('MF_returnfrommission', {

										})
									}
								/>
								: "Not everyone is back in the car."
							:
							"Mission started but not complete yet."
						:
						null

				}
				<Stack.Item grow={1} basis={0}>
					{
						currentmissionData?.mission_list_outgoinginvitations?.map((invite) => (
							<InviteSent invite={invite} />
						))
					}
				</Stack.Item>
			</Stack>
			<Stack>
				Your invites:
				<Stack.Item grow={1} basis={0}>
					{
						invitations?.map((invite) => (
							<InviteReceived invite={invite} />
						))
					}
				</Stack.Item>
			</Stack>
		</Section>
	);
};
