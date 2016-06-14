package dm.taichi;

import dm.dialogue.manager.DM;
import sys.dm.Agent;
import sys.dm.taichi.TaiChiAgentLoader;
import sys.dm.taichi.TaiChiAgentRules;

public class TaiChiDM extends Agent{
	public TaiChiDM(){
		super();
	}
	
	@Override
	public void initSystem() {
		// Create new loader
		String basePath="/Users/amnairfan/DialogueSystem/code/DialogueAgent/data/";
		TaiChiAgentLoader loader = new TaiChiAgentLoader("");
		loader.MDP_FILENAME=basePath+"taichi-agent/sequence_data_mdp.txt";
		loader.EMOTION_TRAINING_FILENAME=basePath+"testDocs/";
		loader.QUESTIONS_DB_FILENAME=basePath+"taichi-agent/questions.db";
		
		// Create new DM
		dialogue = new DM(loader);
		
		// Set rules for DM
		// Note: this is for NLU
		dialogue.setRules(new TaiChiAgentRules());
	}
	
	public DM getDialogueManager(){
		return dialogue;
	}
	
	public static void main(String[] args) {
		// Create a new instance of this agent and execute()
		TaiChiDM agent = new TaiChiDM();
		agent.execute();
	}
	
}
