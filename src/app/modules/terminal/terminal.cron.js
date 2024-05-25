import cron from 'node-cron';
import mongoose from 'mongoose';
import { exec } from 'child_process';
import { Request } from './terminal.model.js';


const checkAndExecuteRequests = async () => {
  try {
      // Find pending requests
    const pendingRequests = await Request.find({ status: 'pending' });
    console.log(`cron job started for ${pendingRequests}`)

    for (const request of pendingRequests) {
      await executeCommands(request);
    }

   
  } catch (error) {
    console.error('Error checking and executing requests:', error);
  }
};

const executeCommands = async (request) => {
  const commands = request.commands;
  for (let i = 0; i < commands.length; i++) {
    try {
      await runCommand(commands[i]);
    } catch (error) {
      console.error('Command failed:', commands[i], 'Error:', error);
      await runCommand(request.errorCommand);
      break;
    }
  }

  // Update status to completed
  request.status = 'completed';
  await request.save();
};

const runCommand = (command) => {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error(`Error executing command ${command}:`, stderr);
        reject(error);
      } else {
        console.log(`Command ${command} executed successfully:`, stdout);
        resolve(stdout);
      }
    });
  });
};

// Schedule the cron job to run every minute
cron.schedule('* * * * *', checkAndExecuteRequests);
