import json
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--path", dest="path", type=str, required=True,
                    help="Path to terraform directory (e.g. /home/user/tf)")
args = parser.parse_args()
inventory = f"{args.path}/tf-inventory.ini"

with open(f"{args.path}/terraform.tfstate", "r") as j:
    tfstate = json.load(j)
with open(inventory, "w+") as f:
    f.writelines("### generated by script ###\n")


def read_inv():
    with open(inventory, "r") as f:
        working_inventory = f.read()
        return working_inventory


def main():
    resource_info = tfstate['resources']
    for entries in resource_info:
        if entries['type'] == 'aws_instance':
            if entries['name'] == 'db':
                if "[db]" not in read_inv():
                    with open(inventory, "a") as f:
                        f.writelines("[db]\n")
                for attribute in entries['instances']:
                    instance_name = attribute['attributes']['tags']['Name']
                    public_ip = attribute['attributes']['public_ip']
                    print(f"{instance_name}: {public_ip}")
                    print("___" *10)
                    with open(inventory, "a") as f:
                        f.writelines(f"{instance_name} ansible_host={public_ip}\n")
            elif entries['name'] == 'web':
                if "[web]" not in read_inv():
                    with open(inventory, "a") as f:
                        f.writelines("[web]\n")
                for attribute in entries['instances']:
                    instance_name = attribute['attributes']['tags']['Name']
                    public_ip = attribute['attributes']['public_ip']
                    print(f"{instance_name}: {public_ip}")
                    print("___" *10)
                    with open(inventory, "a") as f:
                        f.writelines(f"{instance_name} ansible_host={public_ip}\n")
    print(f"Saved to {inventory}")


if __name__ == '__main__':
    main()

