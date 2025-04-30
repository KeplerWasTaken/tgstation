import { useBackend } from "../../backend";
import { Section, Stack, Button, Box, Icon } from "../../components";
import { MissionData, NtosMissionFinderData } from "../NtosMissionFinder";


type DifficultyProps = {
	difficulty: string
};

export const Difficulty = (props: DifficultyProps) => {
	const { difficulty } = props;
	switch (difficulty) {
		case "0":
			return <span>
				<Icon
					name={'exclamation-triangle'}
					color={'yellow'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'black'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'black'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'black'}
				/>
			</span>
		case "1":
			return <span>
				<Icon
					name={'exclamation-triangle'}
					color={'yellow'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'yellow'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'black'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'black'}
				/>
			</span>
		case "2":
			return <span>
				<Icon
					name={'exclamation-triangle'}
					color={'orange'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'orange'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'orange'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'black'}
				/>
			</span>
		case "3":
			return <span>
				<Icon
					name={'exclamation-triangle'}
					color={'red'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'red'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'red'}
				/>
				<Icon
					name={'exclamation-triangle'}
					color={'red'}
				/>
			</span>

	}
}
export const Mission = (props) => {
	var { mission } = props as {
		mission: MissionData
	};

	const { act, data } = useBackend<NtosMissionFinderData>();

	return (
		<Section>
			<Stack align="baseline">
				<Stack.Item grow bold>
					Mission: {mission.mission_name} - {mission.mission_type} - Difficulty: <Difficulty difficulty={mission.mission_difficulty.toString()}/>
				</Stack.Item>
				<Stack.Item
					shrink={0}
					textAlign="right"
					color="label"
					nowrap
				>
					{
						(mission.mission_completed) ?

							"Contract Complete" :

							//Is mission taken?
							(mission.mission_hostername && mission.mission_hostername != "N/A") ?
								// Yes, show numbers of signed up players, max players, and who's hosting it
								(mission.mission_list_players ? mission.mission_list_players.length : "0") + "/" + mission.mission_maxplayers + " Contractors - Host: " + mission.mission_hostername
								:
								// Are you in a mission?
								(!data.currentmissionData)
									?
									// You may host it!
									<Button
										bold
										children="Host Mission"
										onClick={() =>
											act('MF_hostmission', {
												mission: mission.mission_name
											})
										}
									/>
									: null
					}
				</Stack.Item>
			</Stack>
			<Box mt={1} italic color="label">
				{mission.mission_description}
			</Box>
		</Section>
	);
};
