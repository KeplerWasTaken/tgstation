//epicstation
import { useState } from 'react';
import { useBackend } from '../backend';

import { Stack, Tabs } from '../components';
import { NtosWindow } from '../layouts';

import { Overview } from './NtosMissionFinder/Overview';
import { Mission } from './NtosMissionFinder/Mission';
import { Contractor } from './NtosMissionFinder/Contractor';

export type NtosMissionFinderData = {
	user: string;
	currentmissionData: MissionData;
	missions: MissionData[];
	contractors: ContractorData[];
	error: string;
	invitations: InviteData[];
	vehicle: MissionVehicleData;
};

export type MissionVehicleData = {
	vehicle_name: string;
};

export type MissionPlayerData = {
	player_name: string;
	player_isready: string;
	player_ckey: string;
};

export type InviteData = {
	inviterName: string;
	missionName: string;
	recipientName: string;
	recipientCkey: string;
	inviterCkey: string;
};

export type ContractorData = {
	name: string;
	busy: boolean;
	ckey: string
};

export type MissionData = {
	mission_hostername: string;
	mission_difficulty: number;
	mission_type: string;
	mission_name: string;
	mission_maxplayers: number;
	mission_description: string;
	mission_list_players: MissionPlayerData[];
	mission_list_outgoinginvitations: InviteData[];
	mission_completed: boolean;
	mission_started: boolean;
	mission_left: boolean;
	mission_timetillexpiration: string;
};

export const NtosMissionFinder = () => {
	const { act, data } = useBackend<NtosMissionFinderData>();

	const {
		missions = [],
		contractors = []
	} = data;

	const all_categories = ["Overview", "Missions", "Contractors"];

	const [selectedCategory, setSelectedCategory] = useState(all_categories[0]);

	return (
		<NtosWindow width={600} height={600}>
			<NtosWindow.Content scrollable>
				<Stack>
					<Stack.Item minWidth="105px" shrink={0} basis={0}>
						<Tabs vertical>
							{all_categories.map((category) => (
								<Tabs.Tab
									key={category}
									selected={category === selectedCategory}
									onClick={() => setSelectedCategory(category)}
								>
									{category}
								</Tabs.Tab>
							))}
						</Tabs>
					</Stack.Item>
					<Stack.Item grow={1} basis={0}>
						{
							(selectedCategory == "Missions"
								&&
								missions?.map((mission) => (
									<Mission mission={mission} />
								))
							)
							||
							(selectedCategory == "Overview" &&
								<Overview />
							)
							||
							(selectedCategory == "Contractors" &&
								contractors?.map((contractor) => (
									<Contractor contractor={contractor} />
								))
							)
						}
					</Stack.Item>
				</Stack>
			</NtosWindow.Content>
		</NtosWindow>
	);
};
