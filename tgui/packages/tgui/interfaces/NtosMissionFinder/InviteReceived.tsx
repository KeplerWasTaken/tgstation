import { Section, Stack, Button } from "tgui-core/components";
import { useBackend } from "../../backend";
import { NtosMissionFinderData } from "../NtosMissionFinder";

export const InviteReceived = (props) => {
	const { invite } = props;
	const { act, data } = useBackend<NtosMissionFinderData>();

	return (
		<Section>
			<Stack align="baseline">
				<Stack.Item grow bold>
					An invitiation to join: {invite.missionName} by {invite.inviterName}

					<Button
						bold
						children="Accept Invite"
						onClick={() =>
							act('MF_declineinvite', {
								mission: invite.missionName
							})
						}
					/>
				</Stack.Item>
			</Stack>
		</Section>
	);
};
