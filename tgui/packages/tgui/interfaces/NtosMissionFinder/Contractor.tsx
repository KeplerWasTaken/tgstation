import { Section, Stack, Button } from "tgui-core/components";
import { useBackend } from "../../backend";
import { ContractorData, NtosMissionFinderData } from "../NtosMissionFinder";

export const Contractor = (props) => {
	var { contractor } = props;
	contractor = contractor as ContractorData;

	const { act, data } = useBackend<NtosMissionFinderData>();

	const {
		user,
		currentmissionData,
		missions = [],
		contractors = [],
		error
	} = data;

	const isThisUserHostingAMission = currentmissionData && currentmissionData.mission_hostername == user

	return (
		<Section>
			<Stack align="baseline">
				<Stack.Item grow bold>
					{contractor.name} -
					{contractor.busy ?
						(
							<span> Already in a Mission </span>
						)
						:
						isThisUserHostingAMission ?
							(
								<Button
									bold
									children="Invite to Group"
									onClick={() =>
										act('MF_invite', {
											contractor: contractor.ckey
										})
									}
								/>
							)
							:
							(
								<span> Available </span>
							)
					}
				</Stack.Item>
			</Stack>
		</Section>
	);
};
